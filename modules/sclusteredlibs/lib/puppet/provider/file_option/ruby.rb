Puppet::Type.type(:file_option).provide(:ruby) do
  def exists?
    escapeOption = Regexp.escape(resource[:option])
    escapeValue = Regexp.escape(resource[:value])
    regexp = Regexp.new("^\s*#{escapeOption}\s*#{separator}\s*#{escapeValue}")
    lines.find { |line|
      regexp.match(line)
    }
  end

  def create
    # if there are no lines, write directly #
    if lines.length == 0
      File.open(resource[:path], 'w') { |fh|
        fh.puts( "#{resource[:option]}#{resource[:separator]}#{resource[:value]}" ) 
      }
    return
    end

    # create the regexp to find the active options #
    escapeOption = Regexp.escape(resource[:option])
    optionRegexp = Regexp.new("^\s*#{escapeOption}\s*#{separator}")

    ########################################################
    # determine after witch line we need to add the option #
    ########################################################

    # build the regex #    
    if resource[:multiple].to_s != 'true'
      if resource[:after]
        afterRegexp = Regexp.new("(#.*#{escapeOption}\s*#{separator}|#{resource[:after]})")
      else
        afterRegexp = Regexp.new("#.*#{escapeOption}\s*#{separator}")
      end
    else
      if resource[:after]
        afterRegexp = Regexp.new("(#{escapeOption}\s*#{separator}|#{resource[:after]})")
      else
        afterRegexp = Regexp.new("#{escapeOption}\s*#{separator}")
      end
    end

    # get the line index #
    afterLineIdx = lines.rindex { |line| afterRegexp.match(line) } 
    if ! afterLineIdx
      afterLineIdx = lines.length - 1
    end 

    # write the result #
    optionInserted = false
    File.open(resource[:path], 'w') { |fh|
      lines.each_with_index { |line,idx|
       
        # check we need to add the current line #
        # if !multiple remove the other options #
        if resource[:multiple].to_s == 'true' or ! optionRegexp.match( line )
           fh.puts( line )
        else
          if ! optionInserted
            fh.puts( "#{resource[:option]}#{resource[:separator]}#{resource[:value]}" )
            optionInserted = true
          end
          # else remove the option
        end

        # check if it's time to add the option #
        if idx == afterLineIdx and ! optionInserted
          fh.puts( "#{resource[:option]}#{resource[:separator]}#{resource[:value]}" )
          optionInserted = true
        end
      }
    }            
  end

  def destroy
    escapeOption = Regexp.escape(resource[:option])
    escapeValue = Regexp.escape(resource[:value])

    # create the regexp to find the line to destroy #
    if resource[:multiple].to_s == 'true'
      destroyRegexp = Regexp.new("^\s*#{escapeOption}\s*#{separator}\s*#{escapeValue}")
    else
      destroyRegexp = Regexp.new("^\s*#{escapeOption }\s*#{separator}")
    end

    # write to file #
    local_lines = lines
    File.open(resource[:path],'w') { |fh|
      fh.write(local_lines.reject{|l| destroyRegexp.match(l) }.join(''))
    }
  end

  private
  def lines
    # If this type is ever used with very large files, we should
    #  write this in a different way, using a temp
    #  file; for now assuming that this type is only used on
    #  small-ish config files that can fit into memory without
    #  too much trouble.
    @lines ||= File.readlines(resource[:path])
  end

  def separator
    Regexp.escape(resource[:separator].strip)
  end 


end


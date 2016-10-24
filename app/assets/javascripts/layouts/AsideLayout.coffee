module.exports = AppLayoutAside = React.createClass
  render: ->
    <div className='aside-layout'>
      <Aside />
      <Main />
    </div>

# ---------

{ Menu, Icon, Breadcrumb, Alert} = antd
{ SubMenu } = Menu

Aside = React.createClass
  getInitialState: ->
    path = new URI(location.href).path()
    # 新增操作
    path = path.replace(/\/new$/, '')
    # 编辑操作
    path = path.replace(/\/[a-f0-9]+\/edit$/, '')

    path = '/' if ['/manager'].indexOf(path) > -1

    selected_url: path

  render: ->
    menudata = window.role_menus_data

    <aside className='layout-sider'>
      <ToggleRole role_strs={window.current_user?.role_strs} />

      <Menu 
        mode='inline' 
        theme='dark' 
        defaultOpenKeys={menudata.map (x)-> x.subkey}
        defaultSelectedKeys={[@state.selected_url]}
      >
        {
          href = "/?role=#{window.current_role}"
          <Menu.Item key="/">
            <MenuLink href={href} icon='home'>总控面板</MenuLink>
          </Menu.Item>
        }
        {
          for sub in menudata
            <SubMenu key={sub.subkey} title={<span><Icon type={sub.subicon} /> {sub.subname}</span>}>
            {
              for menu in sub.menus
                <Menu.Item key={menu.href}>
                  <MenuLink href={menu.href} icon={menu.icon}>{menu.name}</MenuLink>
                </Menu.Item>
            }
            </SubMenu>
        }
      </Menu>
    </aside>


MenuLink = React.createClass
  render: ->
    {href, icon} = @props

    <a href={href} onClick={@click}>
      <span className='nav-text'>
        {@props.children}
      </span>
    </a>

  click: (evt)->
    evt.preventDefault()
    evt.stopPropagation()
    Turbolinks.visit @props.href

# -----------

Main = React.createClass
  render: ->
    <div className='layout-main'>
      <TopMenu />
      <div className='layout-content' style={maxWidth: 1200 - 180}>
        <YieldComponent component={window.content_component} />
      </div>
    </div>

TopMenu = React.createClass
  render: ->
    <div className='top-menu'>
      <BC />
      <SignOut />
    </div>


BC = React.createClass
  render: ->
    <div />


SignOut = React.createClass
  render: ->
    <a className='sign-out' onClick={@sign_out}>
      <Icon type='logout' /> 登出
    </a>

  sign_out: ->
    jQuery.ajax
      url: '/api/sign_out'
      type: 'delete'
    .done =>
      location.href = '/'


ToggleRole = React.createClass
  render: ->
    { Select, Icon } = antd
    { Option } = Select
    
    <div style={margin: '5px'}>
      <Select
        style={width: '100%'}
        placeholder='切换角色'
        onChange={@toggle}
        defaultValue={window.current_role}
      >
        {
          for role, str of @props.role_strs
            <Option key={role} value={role}>
              <Icon type='solution' /> {str}
            </Option>
        }
      </Select>
    </div>

  toggle: (role)->
    location.href = "/?role=#{role}"
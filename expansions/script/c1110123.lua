--
function c1110123.initial_effect(c)
--
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c1110123.con1)
	e1:SetOperation(c1110123.op1)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,1110123)
	e2:SetCondition(c1110123.con2)
	e2:SetTarget(c1110123.tg2)
	e2:SetOperation(c1110123.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1110123,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,1110128)
	e3:SetCost(c1110123.cost3)
	e3:SetTarget(c1110123.tg3)
	e3:SetOperation(c1110123.op3)
	c:RegisterEffect(e3)
--
end
--
c1110123.xyz_count=2
--
function c1110123.IsLq(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lq
end
--
function c1110123.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,3)
end
--
function c1110123.xyzcheck(g,xyzc,exg)
	local ct=g:GetCount()
	return g:CheckWithSumEqual(c1110123.val(exg),6,ct,ct)
end
function c1110123.val(exg)
	return  
	function(c)
		return exg:IsContains(c) and c:GetLevel() or 3
	end
end
--
function c1110123.XyzProcedureCustomFilter(c,xyzcard,func,ext_params)
	if c:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED) and c:IsFacedown() then return false end
	return c:IsCanBeXyzMaterial(xyzcard) and (not func or func(c,xyzcard,table.unpack(ext_params)))
end
--
function c1110123.tokenfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsReleasable() and c:IsLevelBelow(3)
end
--
function c1110123.CheckGroup(g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	if min>max then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	if ct>=min and ct<max and f(sg,...) then return true end
	return g:IsExists(c1110123.CheckGroupRecursive,1,nil,sg,g,f,min,max,ext_params)
end
function c1110123.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	if sg:IsContains(c) then return false end
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(c1110123.CheckGroupRecursive,1,nil,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
--
function c1110123.CheckFieldFilter(g,tp,c,f,...)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)+g:FilterCount(aux.FConditionCheckF,nil,tp)>0 and (not f or f(g,...))
end
--
function c1110123.con1(e,c,og,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local func=c1110123.mfilter
	local gf=c1110123.xyzcheck
	local ext_params={}
	local minc=2
	local maxc=4
	if min then
		minc=math.max(minc,min)
		maxc=math.min(maxc,max)
	end
	local mg=nil
	local exg=Group.CreateGroup()
	if og then
		mg=og:Filter(c1110123.XyzProcedureCustomFilter,nil,c,func,ext_params)
		exg=og:Filter(c1110123.tokenfilter,nil)
	else
		mg=Duel.GetMatchingGroup(c1110123.XyzProcedureCustomFilter,tp,LOCATION_MZONE,0,nil,c,func,ext_params)
		exg=Duel.GetMatchingGroup(c1110123.tokenfilter,tp,LOCATION_MZONE,0,nil)
		mg:Merge(exg)
	end
	return maxc>=minc and c1110123.CheckGroup(mg,c1110123.CheckFieldFilter,nil,minc,maxc,tp,c,gf,c,exg)
end
--
function c1110123.SelectGroup(tp,desc,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	while ct<max and not (ct>=min and f(sg,...) and not (g:IsExists(c1110123.CheckGroupRecursive,1,nil,sg,g,f,min,max,ext_params) and Duel.SelectYesNo(tp,210))) do
		Duel.Hint(HINT_SELECTMSG,tp,desc)
		local tg=g:FilterSelect(tp,c1110123.CheckGroupRecursive,1,1,nil,sg,g,f,min,max,ext_params)
		sg:Merge(tg)
		ct=sg:GetCount()
	end
	return sg
end
--
function c1110123.OverlayFilter(c,nchk)
	return nchk or not c:IsType(TYPE_TOKEN)
end
function c1110123.OverlayGroup(c,g,xm,nchk)
	if not nchk and (not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() or g:GetCount()<=0 or not c:IsType(TYPE_XYZ)) then return end
	local tg=g:Filter(c1110123.OverlayFilter,nil,nchk)
	if tg:GetCount()==0 then return end
	local og=Group.CreateGroup()
	for tc in aux.Next(tg) do
		if tc:IsStatus(STATUS_LEAVE_CONFIRMED) then
			tc:CancelToGrave()
		end
		og:Merge(tc:GetOverlayGroup())
	end
	if og:GetCount()>0 then
		if xm then
			Duel.Overlay(c,og)
		else
			Duel.SendtoGrave(og,REASON_RULE)
		end
	end
	Duel.Overlay(c,tg)
end
--
function c1110123.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=nil
	local exg=Group.CreateGroup()
	if og and not min then
		g=og
	else
		local func=c1110123.mfilter
		local gf=c1110123.xyzcheck
		local ext_params={}
		local mg=nil
		if og then
			mg=og:Filter(c1110123.XyzProcedureCustomFilter,nil,c,func,ext_params)
			exg=og:Filter(c1110123.tokenfilter,nil)
		else
			mg=Duel.GetMatchingGroup(c1110123.XyzProcedureCustomFilter,tp,LOCATION_MZONE,0,nil,c,func,ext_params)
			exg=Duel.GetMatchingGroup(c1110123.tokenfilter,tp,LOCATION_MZONE,0,nil)
			mg:Merge(exg)
		end
		local minc=2
		local maxc=4
		if min then
			minc=math.max(minc,min)
			maxc=math.min(maxc,max)
		end
		g=c1110123.SelectGroup(tp,HINTMSG_XMATERIAL,mg,c1110123.CheckFieldFilter,nil,minc,maxc,tp,c,gf,c,exg)
	end
	c:SetMaterial(g)
	local rg=g:Filter(function(c) return exg:IsContains(c) end,nil)
	g:Sub(rg)
	Duel.Release(rg,REASON_COST+REASON_MATERIAL)
	c1110123.OverlayGroup(c,g,false,true)
end
--
function c1110123.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
--
function c1110123.tfilter2(c)
	return c1110123.IsLq(c)
end
function c1110123.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c1110123.tfilter2,tp,LOCATION_DECK,0,1,nil) end
end
--
function c1110123.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectMatchingCard(tp,c1110123.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
--
function c1110123.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
--
function c1110123.tfilter3(c)
	return c:IsAbleToGrave() and c:IsFaceup()
end
function c1110123.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(c1110123.tfilter3,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c1110123.tfilter3,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,LOCATION_ONFIELD)
end
--
function c1110123.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_ONFIELD) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
--

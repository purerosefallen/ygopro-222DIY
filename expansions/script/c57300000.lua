miyuki=miyuki or {}
local cm=miyuki
--updated overlay
function cm.overlaycard(c,tc,xm,nchk)
	if not nchk and (not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() or not c:IsType(TYPE_XYZ) or tc:IsType(TYPE_TOKEN)) then return end
	if tc:IsStatus(STATUS_LEAVE_CONFIRMED) then
		tc:CancelToGrave()
	end
	if tc:GetOverlayCount()>0 then
		local og=tc:GetOverlayGroup()
		if xm then
			Duel.Overlay(c,og)
		else
			Duel.SendtoGrave(og,REASON_RULE)
		end
	end
	Duel.Overlay(c,tc)
end
function cm.overlayfilter(c,nchk)
	return nchk or not c:IsType(TYPE_TOKEN)
end
function cm.overlaygroup(c,g,xm,nchk)
	if not nchk and (not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() or g:GetCount()<=0 or not c:IsType(TYPE_XYZ)) then return end
	local tg=g:Filter(cm.overlayfilter,nil,nchk)
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
--xyz summon of prim
function cm.rxyz1(c,rk,f,minct,maxct,xm,...)
	local ext_params={...}
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.xyzcon1(rk,f,minct,maxct,ext_params))
	e1:SetOperation(cm.xyzop1(rk,f,minct,maxct,xm,ext_params))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	return e1
end
function cm.mfilter(c,xyzc,rk,f,ext_params)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and c:IsCanBeXyzMaterial(xyzc) and (not rk or c:GetRank()==rk) and (not f or f(c,xyzc,table.unpack(ext_params)))
end
function cm.xyzfilter1(c,tp,g,xyzc,minc,maxc)
	local tg=g:Filter(cm.xyzfilter2,c,c:GetRank())
	return cm.CheckGroup(tg,cm.CheckFieldFilter,Group.FromCards(c),minc,maxc,tp,xyzc)
end
function cm.xyzfilter2(c,rk)
	return c:GetRank()==rk
end
function cm.CheckFieldFilter(g,tp,c,f,...)
	return Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and (not f or f(g,...))
end
function cm.xyzcon1(rk,f,minct,maxct,ext_params)
return function(e,c,og,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local minc=minct or 2
	local maxc=maxct or minct or 63
	if min then
		minc=math.max(minc,min)
		maxc=math.min(maxc,max)
	end
	local mg=nil
	if og then
		mg=og:Filter(cm.mfilter,nil,c,rk,f,ext_params)
	else
		mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,0,nil,c,rk,f,ext_params)
	end
	return maxc>=minc and mg:IsExists(cm.xyzfilter1,1,nil,tp,mg,c,minc,maxc)
end
end
function cm.xyzop1(rk,f,minct,maxct,xm,ext_params)
return function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(cm.mfilter,nil,c,rk,f,ext_params)
		else
			mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,0,nil,c,rk,f,ext_params)
		end
		local minc=minct or 2
		local maxc=maxct or minct or 63
		if min then
			minc=math.max(minc,min)
			maxc=math.min(maxc,max)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g1=mg:FilterSelect(tp,cm.xyzfilter1,1,1,nil,tp,mg,c,minc,maxc)
		local tg=mg:Filter(cm.xyzfilter2,g1:GetFirst(),g1:GetFirst():GetRank())
		g=cm.SelectGroup(tp,HINTMSG_XMATERIAL,tg,cm.CheckFieldFilter,g1,minc,maxc,tp,c)
	end
	c:SetMaterial(g)
	cm.overlaygroup(c,g,xm,true)
end
end

function cm.rxyz2(c,rk,f,ct,xm,...)
	return cm.rxyz1(c,rk,f,ct,ct,xm,...)
end
function cm.rxyz3(c,func,gf,minc,maxc,xm,...)
	local ext_params={...}
	c:EnableReviveLimit()
	local maxc=maxc or minc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.rxyz3Condition(func,gf,minc,maxc,ext_params))
	e1:SetOperation(cm.rxyz3Operation(func,gf,minc,maxc,xm,ext_params))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	return e1
end
function cm.rxyz3Filter(c,xyzcard,func,ext_params)
	if c:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED) and c:IsFacedown() then return false end
	return c:IsCanBeXyzMaterial(xyzcard) and (not func or func(c,xyzcard,table.unpack(ext_params)))
end
function cm.rxyz3Condition(func,gf,minct,maxct,ext_params)
	return function(e,c,og,min,max)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local minc=minct or 2
		local maxc=maxct or minct or 63
		if min then
			minc=math.max(minc,min)
			maxc=math.min(maxc,max)
		end
		local mg=nil
		if og then
			mg=og:Filter(cm.rxyz3Filter,nil,c,func,ext_params)
		else
			mg=Duel.GetMatchingGroup(cm.rxyz3Filter,tp,LOCATION_MZONE,0,nil,c,func,ext_params)
		end
		return maxc>=minc and cm.CheckGroup(mg,cm.CheckFieldFilter,nil,minc,maxc,tp,c,gf,c)
	end
end
function cm.rxyz3Operation(func,gf,minct,maxct,xm,ext_params)
	return function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
		local g=nil
		if og and not min then
			g=og
		else
			local mg=nil
			if og then
				mg=og:Filter(cm.rxyz3Filter,nil,c,func,ext_params)
			else
				mg=Duel.GetMatchingGroup(cm.rxyz3Filter,tp,LOCATION_MZONE,0,nil,c,func,ext_params)
			end
			local minc=minct or 2
			local maxc=maxct or minct or 63
			if min then
				minc=math.max(minc,min)
				maxc=math.min(maxc,max)
			end
			g=cm.SelectGroup(tp,HINTMSG_XMATERIAL,mg,cm.CheckFieldFilter,nil,minc,maxc,tp,c,gf,c)
		end
		c:SetMaterial(g)
		cm.overlaygroup(c,g,xm,true)
	end
end
function cm.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function cm.CheckGroup(g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	if min>max then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	if ct>=min and ct<max and f(sg,...) then return true end
	return g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params)
end
function cm.SelectGroup(tp,desc,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then
		sg:Merge(cg)
	end
	local ct=sg:GetCount()
	local ag=g:Filter(cm.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)	
	while ct<max and ag:GetCount()>0 do
		local minc=1
		local finish=(ct>=min and f(sg,...))
		if finish then
			minc=0
			if not Duel.SelectYesNo(tp,210) then break end
		end
		Duel.Hint(HINT_SELECTMSG,tp,desc)
		local tg=ag:Select(tp,minc,1,nil)
		if tg:GetCount()==0 then break end
		sg:Merge(tg)
		ct=sg:GetCount()
		ag=g:Filter(cm.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)
	end
	return sg
end
function cm.exgoal(g,tp,fc)
	return Duel.GetLocationCountFromEx(tp,tp,g,fc)>0
end
function cm.CheckSummonLocation(c,tp)
	if c:IsLocation(LOCATION_EXTRA) then return Duel.GetLocationCountFromEx(tp)>0 end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.AND(...)
	local t={...}
	return function(...)
		local res=false
		for i,f in pairs(t) do
			res=f(...)
			if not res then return res end
		end
		return res
	end
end
function cm.OR(...)
	local t={...}
	return function(...)
		local res=false
		for i,f in pairs(t) do
			res=f(...)
			if res then return res end
		end
		return res
	end
end
function cm.NOT(f)
	return function(...)
		return not f(...)
	end
end
function cm.serlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.neg(c,lmct,lmcd,cost,excon,exop,loc,force)
	local e3=Effect.CreateEffect(c)
	loc=loc or LOCATION_MZONE
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	if force then
		e3:SetType(EFFECT_TYPE_QUICK_F)
	else
		e3:SetType(EFFECT_TYPE_QUICK_O)
	end
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(lmct,lmcd)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(loc)
	e3:SetCondition(cm.negcon(excon))
	if cost then e3:SetCost(cost) end
	e3:SetTarget(cm.negtg)
	e3:SetOperation(cm.negop(exop))
	c:RegisterEffect(e3)
	return e3
end
function cm.negcon(excon)
return function(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
end
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.negop(exop)
return function(e,tp,eg,ep,ev,re,r,rp)
	local chk=Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	if chk and exop then
		exop(e,tp,eg,ep,ev,re,r,rp)
	end
end
end
function cm.negtrap(c,lmct,lmcd,cost,excon,exop)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(lmct,lmcd)
	e1:SetCondition(cm.negcon(excon))
	if cost then e1:SetCost(cost) end
	e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.negop(exop))
	c:RegisterEffect(e1)
end
function cm.isdoll(c)
	local codet={c:GetCode()}
	for i,code in pairs(codet) do
		local mt=_G["c"..code]
		if not mt then
			_G["c"..code]={}
			if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
				mt=_G["c"..code]
				_G["c"..code]=nil
			else
				_G["c"..code]=nil
			end
		end
		if mt and mt.named_with_doll then return true end
	end
	return false
end
function cm.isfusiondoll(c)
	if c:IsHasEffect(6205579) then return false end
	local codet={c:GetFusionCode()}
	for i,code in pairs(codet) do
		local mt=_G["c"..code]
		if not mt then
			_G["c"..code]={}
			if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
				mt=_G["c"..code]
				_G["c"..code]=nil
			else
				_G["c"..code]=nil
			end
		end
		if mt and mt.named_with_doll then return true end
	end
	return false
end
function cm.NonImmuneFilter(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.FusionMaterialFilter(c,oppo)
	if oppo and c:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED) and c:IsFacedown() then return false end
	return c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER)
end
function cm.GetFusionMaterial(tp,loc,oloc,f,gc,e,...)
	local g1=Duel.GetFusionMaterial(tp)
	if loc then
		local floc=bit.band(loc,LOCATION_ONFIELD+LOCATION_HAND)
		if floc~=0 then
			g1=g1:Filter(Card.IsLocation,nil,floc)
		else
			g1:Clear()
		end
		local eloc=loc-floc
		if eloc~=0 then
			local g2=Duel.GetMatchingGroup(cm.FusionMaterialFilter,tp,eloc,0,nil)
			g1:Merge(g2)
		end
	end
	if oloc and oloc~=0 then
		local g3=Duel.GetMatchingGroup(cm.FusionMaterialFilter,tp,0,oloc,nil,true)
		g1:Merge(g3)
	end
	if f then g1=g1:Filter(f,nil,...) end
	if gc then g1:RemoveCard(gc) end
	if e then g1=g1:Filter(cm.NonImmuneFilter,nil,e) end
	return g1
end
function cm.dollcost(c)
local dchk=c:IsStatus(STATUS_COPYING_EFFECT) and c:GetFlagEffectLabel(37564768) or 0
return function(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ctlm=math.max(dchk,1)
	if chk==0 then
		if c:GetFlagEffect(57320000)<ctlm then return true end
		if not c.named_with_doll then return false end
		if Duel.IsPlayerAffectedByEffect(tp,57320012) then return true end
		local te2=Duel.IsPlayerAffectedByEffect(tp,57320003)
		if te2 and te2:GetOwner():IsAbleToGraveAsCost() then return true end
		return false
	end
	if c:GetFlagEffect(57320000)<ctlm then
		c:RegisterFlagEffect(57320000,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		return
	end
	local te1=Duel.IsPlayerAffectedByEffect(tp,57320012)
	if te1 then
		te1:Reset()
		return
	end
	local te2=Duel.IsPlayerAffectedByEffect(tp,57320003)
	if te2 then 
		Duel.SendtoGrave(te2:GetOwner(),REASON_COST)
		return
	end
end
end

function cm.IsWindbot(c)
	local codet={c:GetCode()}
	for i,code in pairs(codet) do
		local mt=_G["c"..code]
		if not mt then
			_G["c"..code]={}
			if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
				mt=_G["c"..code]
				_G["c"..code]=nil
			else
				_G["c"..code]=nil
			end
		end
		if mt and mt.named_with_windbot then return true end
	end
	return false
end
function cm.IsFusionWindbot(c)
	local codet={c:GetFusionCode()}
	for i,code in pairs(codet) do
		local mt=_G["c"..code]
		if not mt then
			_G["c"..code]={}
			if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
				mt=_G["c"..code]
				_G["c"..code]=nil
			else
				_G["c"..code]=nil
			end
		end
		if mt and mt.named_with_windbot then return true end
	end
	return false
end
function cm.IsSanae(c)
	local codet={c:GetCode()}
	for i,code in pairs(codet) do
		local mt=_G["c"..code]
		if not mt then
			_G["c"..code]={}
			if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
				mt=_G["c"..code]
				_G["c"..code]=nil
			else
				_G["c"..code]=nil
			end
		end
		if mt and mt.named_with_sanae then return true end
	end
	return false
end
function cm.WindbotCommonEffect(c,tg,op,expr,ctg)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(57300000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.WindbotSSCost)
	e1:SetTarget(cm.WindbotSSTarget)
	e1:SetOperation(cm.WindbotSSOperation)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e1:SetCategory(ctg)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+expr)
	e1:SetCountLimit(1,c:GetOriginalCode())
	e1:SetTarget(tg)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
end
function cm.WindbotSSCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.WindbotSSFilter(c,e,tp)
	return cm.IsWindbot(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsCode(e:GetHandler():GetCode())
end
function cm.WindbotSSTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(cm.WindbotSSFilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function cm.WindbotSSOperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.WindbotSSFilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function cm.SanaeCostFilter(c)
	return c:IsCode(57330007) and c:IsAbleToRemoveAsCost() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.SanaeCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.SanaeCostFilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.SanaeCostFilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--花舞少女·随花起舞
local m=14141006
local cm=_G["c"..m]
if cm then
cm.named_with_hana=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return c:IsFaceup() and scorp.check_set_hana(c) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function cm.spfilter(c,e,tp,code)
	return scorp.check_set_hana(c) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end



end
--module part
if not scorp then
scorp={}
scorp.loaded_metatable_list={}
function scorp.load_metatable(code)
	local m1=_G["c"..code]
	if m1 then return m1 end
	local m2=scorp.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
			scorp.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end
function scorp.check_set(c,setcode,v,f,...) 
	local codet=nil
	if type(c)=="number" then
		codet={c}
	elseif type(c)=="table" then
		codet=c
	elseif type(c)=="userdata" then
		local f=f or Card.GetCode
		codet={f(c)}
	end
	local ncodet={...}
	for i,code in pairs(codet) do
		for i,ncode in pairs(ncodet) do
			if code==ncode then return true end
		end
		local mt=scorp.load_metatable(code)
		if mt and mt["named_with_"..setcode] and (not v or mt["named_with_"..setcode]==v) then return true end
	end
	return false
end
function scorp.check_set_hana(c)
	return scorp.check_set(c,"hana")
end
function scorp.hana_common_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(scorp.splimit)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(14141001,1))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetCondition(scorp.ntcon)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(14141001,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,c:GetOriginalCode()+10000)
	e2:SetCondition(aux.exccon)
	e2:SetCost(scorp.setdcost)
	e2:SetTarget(scorp.sptg)
	e2:SetOperation(scorp.spop)
	c:RegisterEffect(e2)
end
function scorp.splimit(e,se,sp,st)
	if not se then return false end
	return scorp.check_set_hana(se:GetHandler())
end
function scorp.ntcon(e,c,minc)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE+LOCATION_EXTRA,0)==0
end
function scorp.setdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function scorp.sethcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function scorp.hanaspfilter(c,e,tp,code)
	if code and c:IsCode(code) then return false end
	return scorp.check_set_hana(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function scorp.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(scorp.hanaspfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function scorp.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,scorp.hanaspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function scorp.hana_effect_register(c,e,m,tg,op)
	local tg=tg or e:GetTarget() or aux.TRUE
	local op=op or e:GetOperation() or aux.TRUE
	e:SetCost(scorp.sethcost)
	e:SetTarget(scorp.hana_target(tg,m))
	e:SetOperation(scorp.hana_operation(op,m))
	e:SetCategory(bit.band(e:GetCategory(),CATEGORY_SPECIAL_SUMMON))
	c:RegisterEffect(e)
end
function scorp.hana_target(tg,m)
return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
	if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(scorp.hanaspfilter,tp,LOCATION_HAND,0,1,nil,e,tp,m) end
	tg(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
end
function scorp.hana_operation(op,m)
return function(e,tp,eg,ep,ev,re,r,rp)
	if not op(e,tp,eg,ep,ev,re,r,rp) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,scorp.hanaspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,m)
	local tc=g:GetFirst()
	Duel.BreakEffect()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TO_HAND)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(aux.Stringid(14141001,3))
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
end

function scorp.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(scorp.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function scorp.CheckGroup(g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	if min>max then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	if ct>=min and ct<max and f(sg,...) then return true end
	return g:IsExists(scorp.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params)
end
function scorp.SelectGroup(tp,desc,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then
		sg:Merge(cg)
	end
	local ct=sg:GetCount()
	local ag=g:Filter(scorp.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)	
	while ct<max and ag:GetCount()>0 do
		local minc=1
		local finish=(ct>=min and f(sg,...))
		if finish then minc=0 end
		Duel.Hint(HINT_SELECTMSG,tp,desc)
		local tg=ag:Select(tp,minc,1,nil)
		if tg:GetCount()==0 then break end
		sg:Merge(tg)
		ct=sg:GetCount()
		ag=g:Filter(scorp.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)
	end
	return sg
end
--end
--updated overlay
function scorp.OverlayCard(c,tc,xm,nchk)
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
function scorp.OverlayFilter(c,nchk)
	return nchk or not c:IsType(TYPE_TOKEN)
end
function scorp.OverlayGroup(c,g,xm,nchk)
	if not nchk and (not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() or g:GetCount()<=0 or not c:IsType(TYPE_XYZ)) then return end
	local tg=g:Filter(scorp.OverlayFilter,nil,nchk)
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
function scorp.AddXyzProcedureCustom(c,func,gf,minc,maxc,xm,...)
	local ext_params={...}
	c:EnableReviveLimit()
	local maxc=maxc or minc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(scorp.XyzProcedureCustomCondition(func,gf,minc,maxc,ext_params))
	e1:SetOperation(scorp.XyzProcedureCustomOperation(func,gf,minc,maxc,xm,ext_params))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	return e1
end
function scorp.XyzProcedureCustomFilter(c,xyzcard,func,ext_params)
	if c:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED) and c:IsFacedown() then return false end
	return c:IsCanBeXyzMaterial(xyzcard) and (not func or func(c,xyzcard,table.unpack(ext_params)))
end
function scorp.CheckFieldFilter(g,tp,c,f,...)
	if f and not f(g,...) then return false end
	if Duel.GetLocationCountFromEx then return Duel.GetLocationCountFromEx(tp,tp,g,c)>0 end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)+g:FilterCount(aux.FConditionCheckF,nil,tp)>0
end
function scorp.XyzProcedureCustomCondition(func,gf,minct,maxct,ext_params)
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
			mg=og:Filter(scorp.XyzProcedureCustomFilter,nil,c,func,ext_params)
		else
			mg=Duel.GetMatchingGroup(scorp.XyzProcedureCustomFilter,tp,LOCATION_MZONE,0,nil,c,func,ext_params)
		end
		return maxc>=minc and scorp.CheckGroup(mg,scorp.CheckFieldFilter,nil,minc,maxc,tp,c,gf,c)
	end
end
function scorp.XyzProcedureCustomOperation(func,gf,minct,maxct,xm,ext_params)
	return function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
		local g=nil
		if og and not min then
			g=og
		else
			local mg=nil
			if og then
				mg=og:Filter(scorp.XyzProcedureCustomFilter,nil,c,func,ext_params)
			else
				mg=Duel.GetMatchingGroup(scorp.XyzProcedureCustomFilter,tp,LOCATION_MZONE,0,nil,c,func,ext_params)
			end
			local minc=minct or 2
			local maxc=maxct or minct or 63
			if min then
				minc=math.max(minc,min)
				maxc=math.min(maxc,max)
			end
			g=scorp.SelectGroup(tp,HINTMSG_XMATERIAL,mg,scorp.CheckFieldFilter,nil,minc,maxc,tp,c,gf,c)
		end
		c:SetMaterial(g)
		scorp.OverlayGroup(c,g,xm,true)
	end
end

end
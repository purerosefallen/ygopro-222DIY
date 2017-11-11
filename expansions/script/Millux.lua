Millux={}
os=require('os')
table=require('table')
io=require('io')
function Millux.rabat_return(c,code,num)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation
		(function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(code,num))
			e1:SetCategory(CATEGORY_TOHAND)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCondition(
			function(e,tp,eg,ep,ev,re,r,rp)
				return not e:GetHandler():IsHasEffect(50008207)
			end)
			e1:SetTarget(
			function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then return true end
				Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
			end)
			e1:SetOperation(
			function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if c:IsRelateToEffect(e) then
					Duel.SendtoHand(c,nil,REASON_EFFECT)
				end
			end)
			e1:SetReset(RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			e2:SetProperty(0)
			e2:SetCondition(
			function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(50008207)
			end)
			c:RegisterEffect(e2)
		end)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function Millux.return_con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function Millux.penlimit(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(Millux.splimit)
	c:RegisterEffect(e1)
end
function Millux.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsRitualType(TYPE_RITUAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
Millux.loaded_metatable_list=Millux.loaded_metatable_list or {}
function Millux.LoadMetatable(code)
	local m1=_G["c"..code]
	if m1 then return m1 end
	local m2=Millux.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
			Millux.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end
function Millux.is_series(c,series,v,f,...) 
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
		local mt=Millux.LoadMetatable(code)
		if mt and mt["is_series_with_"..series] and (not v or mt["is_series_with_"..series]==v) then return true end
	end
	return false
end
function Millux.cannot_acctivate(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(aclimit)
	e1:SetCondition(actcon)
	c:RegisterEffect(e1)
end
function aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
return Millux

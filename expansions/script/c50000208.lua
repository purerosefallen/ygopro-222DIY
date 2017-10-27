--灵依魔法·唤灵
function c50000208.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c50000208.condition)
	e1:SetCost(c50000208.cost)
	e1:SetTarget(c50000208.target)
	e1:SetOperation(c50000208.activate)
	c:RegisterEffect(e1)
end
c50000208.is_named_with_Rely=1
function c50000208.IsRely(c)
	local code=c:GetCode()
	local mt=_G["c"..code]
	if not mt then
		_G["c"..code]={}
		if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
			mt=_G["c"..code]
			_G["c"..code]=nil
		else
			_G["c"..code]=nil
			return false
		end
	end
	return mt and mt.is_named_with_Rely
end
function c50000208.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c50000208.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetLabelObject(e)
	e2:SetTarget(c50000208.splimit)
	Duel.RegisterEffect(e2,tp)
end
function c50000208.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se~=e:GetLabelObject()
end
function c50000208.filter(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)
end
function c50000208.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c50000208.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c50000208.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c50000208.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)~=0  then
		tc:RegisterFlagEffect(50000208,RESET_EVENT+0x1fe0000,0,1)
		tc:CompleteProcedure()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(tc)
		e2:SetCondition(c50000208.descon)
		e2:SetOperation(c50000208.desop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c50000208.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(50000208)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c50000208.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
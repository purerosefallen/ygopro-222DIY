--3L·Time Machine
local m=37564818
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(Senya.SelfReleaseCost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.effect_operation_3L(c)
	local ex1=Effect.CreateEffect(c)
	ex1:SetType(EFFECT_TYPE_FIELD)
	ex1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	ex1:SetRange(LOCATION_MZONE)
	ex1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ex1:SetTargetRange(0xff,0xff)
	ex1:SetValue(LOCATION_DECK)
	ex1:SetTarget(function(e,c)
		return c:GetOwner()~=e:GetHandlerPlayer()
	end)
	ex1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(ex1,true)
	local ex2=ex1:Clone()
	ex2:SetCode(EFFECT_CANNOT_TO_GRAVE)
	ex2:SetTargetRange(0,LOCATION_DECK+LOCATION_EXTRA)
	ex2:SetTarget(function(e,c)
		return c:GetOwner()~=e:GetHandlerPlayer() and (c:IsLocation(LOCATION_DECK)
			or (c:IsLocation(LOCATION_EXTRA) and (c:GetOriginalType() & TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)~=0))
	end)
	ex2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(ex2,true)
	return ex1,ex2
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Senya.check_set_3L(c) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(e:GetHandler()),c)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
		tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(tc)
		e2:SetCondition(cm.descon)
		e2:SetOperation(cm.desop)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
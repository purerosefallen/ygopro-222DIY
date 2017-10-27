--3L·随花起舞
local m=37564817
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function cm.effect_operation_3L(c,ctlm)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetDescription(m*16+1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(ctlm)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCost(Senya.DescriptionCost())
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return re~=e
	end)
	e1:SetOperation(cm.op)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1,true)
	return e1
end
function cm.filter(c,e,tp)
	return Senya.check_set_3L(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		--[[local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)]]
		Duel.SpecialSummonComplete()
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetValue(function(e,te)
		return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
	end)
	e1:SetTarget(function(e,c)
		return Senya.check_set_3L(c) and c:IsFaceup()
	end)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
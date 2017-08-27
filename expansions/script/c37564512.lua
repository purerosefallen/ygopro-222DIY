--Eternal Fantasy
local m=37564512
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	--Activate(effect)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(cm.condition2)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
	Senya.NanahiraTrap(c,e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(function(e)
		local tp=e:GetHandlerPlayer()
		return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,true)
	end)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,ori)
	if c:IsFacedown() then return false end
	if ori then return c:GetOriginalCode()==37564765 and c:IsLocation(LOCATION_MZONE) end
	if c:IsCode(37564765) then return true end
	return (Senya.check_set_sawawa(c) or (Senya.check_set_3L(c) and c:IsType(TYPE_FUSION)) or (Senya.check_set_sayuri(c) and bit.band(c:GetType(),0x81)==0x81)) and c:IsLocation(LOCATION_MZONE)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil,false)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

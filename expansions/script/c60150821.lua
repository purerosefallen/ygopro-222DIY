--爱莎-烈焰骸龙
function c60150821.initial_effect(c)
    c:SetSPSummonOnce(60150821)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c60150821.sprcon)
	e2:SetOperation(c60150821.sprop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
    e3:SetCost(c60150821.atkcost)
    e3:SetOperation(c60150821.atkop)
    c:RegisterEffect(e3)
	--get effect
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e4:SetCondition(c60150821.damcon)
    e4:SetOperation(c60150821.damop)
    c:RegisterEffect(e4)
end
function c60150821.spfilter1(c,tp)
	return c:IsFusionSetCard(0x3b23) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c60150821.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c60150821.spfilter2(c)
	return c:IsFusionSetCard(0x3b23) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function c60150821.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>-2
		and Duel.IsExistingMatchingCard(c60150821.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c60150821.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c60150821.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c60150821.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c60150821.cfilter2(c)
    return c:IsFaceup() and c:IsSetCard(0x3b23) and c:IsAbleToDeckOrExtraAsCost()
end
function c60150821.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60150821.cfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c60150814.cfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c60150821.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetValue(c:GetBaseAttack()*2)
        c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e2)
    end
end
function c60150821.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetRace()==RACE_SPELLCASTER and c:GetAttribute()==ATTRIBUTE_DARK 
		and ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c60150821.damop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():GetBattleTarget():GetSummonLocation()==LOCATION_EXTRA then
		Duel.ChangeBattleDamage(ep,ev*2)
	end
end

--爱莎-赫尼尔时空
function c60150820.initial_effect(c)
    c:SetSPSummonOnce(60150820)
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
	e2:SetCondition(c60150820.sprcon)
	e2:SetOperation(c60150820.sprop)
	c:RegisterEffect(e2)
	--
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_CHAIN_ACTIVATING)
    e3:SetOperation(c60150820.disop)
    c:RegisterEffect(e3)
	--get effect
	local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_XMATERIAL)
    e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetValue(c60150820.val2)
    e6:SetCondition(c60150820.rmcon2)
    c:RegisterEffect(e6)
end
function c60150820.spfilter1(c,tp)
	return c:IsFusionSetCard(0x3b23) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c60150820.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c60150820.spfilter2(c)
	return c:IsFusionSetCard(0x3b23) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function c60150820.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>-2
		and Duel.IsExistingMatchingCard(c60150820.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c60150820.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c60150820.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c60150820.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c60150820.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if ep==tp then return end
    local rc=re:GetHandler()
	if rc:GetFlagEffect(60150820)~=0 then return end
    local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if (loc==LOCATION_MZONE or loc==LOCATION_SZONE) then 
		Duel.Hint(HINT_CARD,0,60150820)
        local res=0
        res=Duel.TossCoin(tp,1)
        if res==1 then
            if rc:IsRelateToEffect(re) and not rc:IsImmuneToEffect(e) then
                local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(60150820,0))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e1:SetReset(RESET_EVENT+0x47e0000)
				e1:SetValue(LOCATION_REMOVED)
				rc:RegisterEffect(e1,true)
				rc:RegisterFlagEffect(60150820,RESET_EVENT+0x1fe0000,0,1)
            end
        end
    end
end
function c60150820.val2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)
    return (ct1*200)
end
function c60150820.rmcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetRace()==RACE_SPELLCASTER and c:GetAttribute()==ATTRIBUTE_DARK
end
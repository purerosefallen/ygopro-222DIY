--魔创龙 贝琳
function c23305008.initial_effect(c)    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c23305008.ffilter,2,true)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c23305008.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_SPSUMMON_PROC)
    e11:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e11:SetRange(LOCATION_EXTRA)
    e11:SetCondition(c23305008.spcon)
    e11:SetOperation(c23305008.spop)
    c:RegisterEffect(e11)
    --inactivatable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_INACTIVATE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c23305008.efilter)
    c:RegisterEffect(e2)    
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_DISEFFECT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(23305008.efilter)
    c:RegisterEffect(e5)
    --cannot disable summon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c23305008.sumfilter)
    e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)   
    c:RegisterEffect(e4)
    --act limit
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_SUMMON_SUCCESS)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c23305008.sumscon)
    e6:SetOperation(c23305008.sumsuc)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e8:SetRange(LOCATION_FZONE)
    e8:SetCode(EVENT_CHAIN_END)
    e8:SetOperation(c23305008.sumsuc2)
    c:RegisterEffect(e8)
    --todeck
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(23305008,0))
    e10:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e10:SetCode(EVENT_REMOVE)
    e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e10:SetCountLimit(1,23305008)
    e10:SetTarget(c23305008.tdtg)
    e10:SetOperation(c23305008.tdop)
    c:RegisterEffect(e10)  
end
function c23305008.acfilter(c,tp)
    return c:IsSetCard(0x9a1) and bit.band(c:GetType(),0x10002)==0x10002 and (c:GetActivateEffect():IsActivatable(tp) or c:IsSSetable())
end
function c23305008.sumfilter(e,c)
    return c:IsSetCard(0x9a1) and c:GetSummonPlayer()==e:GetHandlerPlayer()
end
function c23305008.sumsuc2(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():GetFlagEffect(23305008)~=0 then
        Duel.SetChainLimitTillChainEnd(c23305008.chainlm)
    end
    e:GetHandler():ResetFlagEffect(23305008)
end
function c23305008.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    if  Duel.GetCurrentChain()==0 then
        Duel.SetChainLimitTillChainEnd(c23305008.chainlm)
    else
        e:GetHandler():RegisterFlagEffect(23305008,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
    end
end
function c23305008.sumscon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c23305008.sfilter,1,nil,tp)
end
function c23305008.sfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x9a1) and c:GetSummonPlayer()==tp
end
function c23305008.chainlm(e,ep,tp)
    return ep==tp
end
function c23305008.efilter(e,ct)
    local p=e:GetHandlerPlayer()
    local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
    return te:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and te:GetHandler():IsSetCard(0x9a1) and p==tp
end
function c23305008.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c23305008.tdfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
    local g=Duel.GetMatchingGroup(c23305008.tdfilter,tp,LOCATION_REMOVED,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),tp,LOCATION_REMOVED)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c23305008.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c23305008.tdfilter,tp,LOCATION_REMOVED,0,nil)
    if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
       Duel.ShuffleDeck(tp)
       Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function c23305008.tdfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsFaceup() and c:IsAbleToDeck()
end
function c23305008.splimit(e,se,sp,st)
    return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION 
end
function c23305008.spfilter(c,tp,fc)
    return c:IsSetCard(0x9a1) and c:IsCanBeFusionMaterial(fc)
end
function c23305008.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
        and Duel.CheckReleaseGroup(tp,c23305008.spfilter,2,nil,tp,c)
end
function c23305008.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,c23305008.spfilter,2,2,nil,tp,c)
    c:SetMaterial(g)
    Duel.Release(g,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
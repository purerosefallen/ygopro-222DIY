--自我的救赎 佐仓杏子
function c60152006.initial_effect(c)
	--special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,6012006)
    e1:SetCondition(c60152006.spcon)
    c:RegisterEffect(e1)
	--
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60152006,0))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,60152006)
    e3:SetTarget(c60152006.sptg)
    e3:SetOperation(c60152006.spop)
    c:RegisterEffect(e3)
end
function c60152006.sfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:GetCode()~=60152006
end
function c60152006.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
        Duel.IsExistingMatchingCard(c60152006.sfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60152006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,60152099,0,0x4011,0,0,4,RACE_PYRO,ATTRIBUTE_FIRE) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c60152006.filter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c60152006.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ct=4
    if ft>ct then ft=ct end
    if ft<=0 then return end
    if not Duel.IsPlayerCanSpecialSummonMonster(tp,60152099,0,0x4011,0,0,4,RACE_PYRO,ATTRIBUTE_FIRE) then return end
    local ctn=true
    while ft>0 and ctn do
        local token=Duel.CreateToken(tp,60152099)
        if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			local atk=Duel.GetMatchingGroupCount(c60152006.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)*400
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_SET_BASE_ATTACK)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetValue(atk)
			token:RegisterEffect(e4,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e3,true)
		end
        ft=ft-1
        if ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(60152006,1)) then ctn=false end
    end
    Duel.SpecialSummonComplete()
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c60152006.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c60152006.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsLocation(LOCATION_EXTRA)
end
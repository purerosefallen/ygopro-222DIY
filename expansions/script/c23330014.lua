--秘调法师 黑玫瑰
function c23330014.initial_effect(c)
	--三角加速同调
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(Card.IsType,TYPE_SYNCHRO),2)
	c:EnableReviveLimit()
	--不能作为融合素材
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--不能作为超量素材
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--融合·超量里侧除外
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23330014,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c23330014.rmtg)
	e3:SetOperation(c23330014.rmop)
	c:RegisterEffect(e3)
	--禁止融合·超量召唤
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c23330014.splimit)
	c:RegisterEffect(e4)
end
function c23330014.rmfilter(c)
	return (c:IsType(TYPE_FUSION) or c:IsType(TYPE_XYZ)) and c:IsAbleToRemove()
end
function c23330014.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c23330014.rmfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c23330014.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c23330014.rmfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,e:GetHandler())
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	local cg=Duel.GetFieldGroup(1-tp,LOCATION_EXTRA,0)
	Duel.ConfirmCards(tp,cg)
end
function c23330014.splimit(e,c,tp,sumtp,sumpos)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and (bit.band(sumtp,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or bit.band(sumtp,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ)
end

--新津 岚舞
function c16080021.initial_effect(c)
	aux.AddSynchroProcedure(c,c16080021.tfilter,aux.NonTuner(),1)
	c:EnableReviveLimit()
	--cannotsp
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c16080021.condition)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c16080021.value)
	c:RegisterEffect(e1)
	--pos change
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetCountLimit(1)
	e2:SetCondition(c16080021.thcon)
	e2:SetOperation(c16080021.thop)
	c:RegisterEffect(e2)
end
function c16080021.tfilter(c)
	return c:IsSetCard(0x5ca)
end
function c16080021.thfilter(c)
	return c:IsSetCard(0x5ca) and c:IsFaceup() and c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) and not c:IsCode(16080021)
end
function c16080021.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c16080021.thfilter,tp,LOCATION_MZONE,0,1,nil) 
end
function c16080021.value(e,c)
	return not c:IsType(TYPE_SYNCHRO) or not c:IsType(TYPE_FUSION) or not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function c16080021.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_CONTINUOUS_POS) and (c:IsPosition(POS_FACEUP_DEFENSE) and c:IsPreviousPosition(POS_FACEUP_ATTACK)) or (c:IsPosition(POS_FACEUP_ATTACK) and c:IsPreviousPosition(POS_FACEUP_DEFENSE)) 
end
function c16080021.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,Card.IsDefensePos,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
	Duel.HintSelection(g)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK,0,POS_FACEUP_ATTACK,0,true)
end
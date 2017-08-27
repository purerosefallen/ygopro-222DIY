--绯樱的神剑姬 厄琳
function c12100001.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(function(e)
		local c=e:GetHandler()
		return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and c:IsRelateToBattle() and c:GetBattleTarget()
	end)
	e1:SetValue(function(e)
		local bc=e:GetHandler():GetBattleTarget()
		if bc:IsType(TYPE_XYZ) then
			return bc:GetRank()*200
		else
			return bc:GetLevel()*200
		end
	end)
	c:RegisterEffect(e1)
end
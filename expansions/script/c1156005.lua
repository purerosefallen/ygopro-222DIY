--识文解意的爱书人
function c1156005.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1156005.matfilter,1)
--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1156005,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c1156005.con2)
	e2:SetTarget(c1156005.tg2)
	e2:SetOperation(c1156005.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1156005,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c1156005.tg2)
	e3:SetOperation(c1156005.op2)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EVENT_FREE_CHAIN+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c1156005.tg4)
	e4:SetOperation(c1156005.op4)
	c:RegisterEffect(e4)
--
end
--
function c1156005.matfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end
--
function c1156005.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
--
function c1156005.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
--
function c1156005.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 then
		Duel.DisableShuffleCheck()
		Duel.ConfirmDecktop(tp,3)
		local g=Duel.GetDecktopGroup(tp,3)
		if Duel.SelectYesNo(tp,aux.Stringid(1156005,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1156005,2))
			local sg=g:Select(tp,1,3,nil)
			local tc=sg:GetFirst()
			while tc do
				g:RemoveCard(tc)
				tc=sg:GetNext()
			end
			local num=g:GetCount()
			if num>0 then
				if num==1 then
					local tc2=g:GetFirst()
					Duel.DisableShuffleCheck()
					Duel.MoveSequence(tc2,1)
				else
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1156005,3))
					local gn=g:Select(tp,1,1,nil)
					local tc2=gn:GetFirst()
					g:RemoveCard(tc2)
					local tc1=g:GetFirst()
					Duel.MoveSequence(tc2,1)
					Duel.MoveSequence(tc1,1)
				end
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1156005,4))
			Duel.SortDecktop(tp,tp,3-num)
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1156005,5))
			local gn=g:Select(tp,1,1,nil)
			local tc3=gn:GetFirst()	  
			g:RemoveCard(tc3)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1156005,3))
			local gn=g:Select(tp,1,1,nil)
			local tc2=gn:GetFirst()
			g:RemoveCard(tc2)
			local tc1=g:GetFirst()
			Duel.MoveSequence(tc3,1)
			Duel.MoveSequence(tc2,1)			
			Duel.MoveSequence(tc1,1)
		end
	end
end
--
function c1156005.tfilter4(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup() and not c:IsDisabled()
end
function c1156005.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone()
	if chk==0 then return Duel.IsExistingMatchingCard(c1156005.tfilter4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and zone~=0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1156006,0,0x4011,800,800,1,RACE_FIEND,ATTRIBUTE_DARK) and Duel.GetTurnPlayer()==e:GetHandler():GetControler() end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end 
--
function c1156005.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1156005)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c1156005.tfilter4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local e4_1=Effect.CreateEffect(tc)
		e4_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4_1:SetType(EFFECT_TYPE_SINGLE)
		e4_1:SetCode(EFFECT_DISABLE)
		e4_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4_1)
		local e4_2=Effect.CreateEffect(tc)
		e4_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4_2:SetType(EFFECT_TYPE_SINGLE)
		e4_2:SetCode(EFFECT_DISABLE_EFFECT)
		e4_2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4_2)
		Duel.BreakEffect()
		if tc:IsDisabled() then
			local zone=e:GetHandler():GetLinkedZone()
			local token=Duel.CreateToken(tp,1156006)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end
--

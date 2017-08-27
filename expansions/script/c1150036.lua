--Cremino Alice
function c1150036.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE+CATEGORY_DICE+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,1150036+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1150036.tg1)
	e1:SetOperation(c1150036.op1)
	c:RegisterEffect(e1)	
--  
end
--
function c1150036.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
end
--
function c1150036.ofilter1(c)
	return c:IsAbleToRemove()
end
function c1150036.ofilter1_roll(c)
	return c:IsAbleToRemove() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsFacedown()
end
function c1150036.ofilter1_monster(c)
	return c:IsType(TYPE_MONSTER)
end
function c1150036.ofilter1_spell(c)
	return c:IsType(TYPE_SPELL)
end
function c1150036.ofilter1_trap(c)
	return c:IsType(TYPE_TRAP)
end
function c1150036.ofilter1_g7(c,e,tp)
	local num=e:GetLabel()
	return c:GetLevel()<num and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK)
end
function c1150036.ofilter1_g9(c)
	return c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c1150036.ofilter1_g11(c)
	return c:IsDestructable()
end
function c1150036.ofilter1_g13(c)
	return c:IsAbleToRemove()
end
function c1150036.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1150036.ofilter1,tp,LOCATION_HAND,0,nil)
	local roll1=0
	local roll2=0
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=Duel.SelectMatchingCard(tp,c1150036.ofliter1,tp,LOCATION_HAND,0,1,1,nil)
		if g1:GetCount()>0 then
			local tc1=g1:GetFirst()
			Duel.Remove(tc1,POS_FACEDOWN,REASON_EFFECT)
			roll1=Duel.TossDice(tp,1)
		end
	end
	local i=1
	while i do
		if roll1>=roll2 then
			local g2=Duel.GetMatchingGroup(c1150036.ofilter1_roll,tp,0,LOCATION_SZONE,nil) 
			if g2:GetCount()>0 then
				if Duel.SelectYesNo(1-tp,aux.Stringid(1150036,0)) then
					Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
					local g3=Duel.SelectMatchingCard(1-tp,c1150036.ofilter1_roll,tp,0,LOCATION_SZONE,1,1,nil)
					if g3:GetCount()>0 then
						local tc3=g3:GetFirst()
						Duel.Remove(tc3,POS_FACEDOWN,REASON_EFFECT)
						roll2=roll2+Duel.TossDice(1-tp,1)
					end
				else
					break 
				end
			end
		end
		if roll1>roll2 then
			break 
		end
		if roll1<=roll2 then
			local g4=Duel.GetMatchingGroup(c1150036.ofilter1,tp,LOCATION_HAND,0,nil) 
			if g4:GetCount()>0 then
				if Duel.SelectYesNo(tp,aux.Stringid(1150036,1)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					local g5=Duel.SelectMatchingCard(tp,c1150036.ofilter1,tp,LOCATION_HAND,0,1,1,nil)
					if g5:GetCount()>0 then
						local tc5=g5:GetFirst()
						Duel.Remove(tc5,POS_FACEDOWN,REASON_EFFECT) 
						roll1=roll1+Duel.TossDice(tp,1)
					end
				else
					break
				end
			end
		end
		if roll2>roll1 then
			break
		end
	end
	Duel.BreakEffect()
	if roll1~=roll2 then
		if roll1>roll2 then
			num=roll1-roll2
			Duel.Damage(tp,roll1*100,REASON_EFFECT)
			Duel.Damage(1-tp,roll2*100,REASON_EFFECT)
			if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 then
				Duel.ConfirmDecktop(tp,3)
				local g6=Duel.GetDecktopGroup(tp,3)
				Duel.ShuffleDeck(tp)
				if g6:GetCount()>0 then
					if g6:IsExists(c1150036.ofilter1_monster,1,nil) then	 
						e:SetLabel(num+1)
						local g7=Duel.GetMatchingGroup(c1150036.ofilter1_g7,tp,LOCATION_GRAVE,0,nil,e,tp) 
						if g7:GetCount()>0 then
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
							local g8=Duel.SelectMatchingCard(tp,c1150036.ofilter1_g7,tp,LOCATION_GRAVE,0,1,1,nil)
							if g8:GetCount()>0 then
								if Duel.SpecialSummon(g8,0,tp,tp,false,false,POS_FACEUP)~=0 then
									Duel.Draw(tp,1,REASON_EFFECT)
								end
							end
						end
					end
					if g6:IsExists(c1150036.ofilter1_spell,1,nil) then
						local g9=Duel.GetMatchingGroup(c1150036.ofilter1_g9,tp,LOCATION_GRAVE,0,nil) 
						if g9:GetCount()>0 then
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
							local g10=Duel.SelectMatchingCard(tp,c1150036.ofilter1_g9,tp,LOCATION_GRAVE,0,1,1,nil)
							if g10:GetCount()>0 then
								if Duel.SSet(tp,g10)~=0 then
									local g11=Duel.GetMatchingGroup(c1150036.ofilter1_g11,tp,0,LOCATION_ONFIELD,nil)  
									if g11:GetCount()>0 then
										Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
										local g12=Duel.SelectMatchingCard(tp,c1150036.ofilter1_g11,tp,0,LOCATION_ONFIELD,1,1,nil)
										if g12:GetCount()>0 then
											Duel.Destroy(g12,REASON_EFFECT)
										end
									end
								end
							end
						end
					end
					if g6:IsExists(c1150036.ofilter1_trap,1,nil) then
						local g13=Duel.GetMatchingGroup(c1150036.ofilter1_g13,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)   
						if g13:GetCount()>0 then
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
							local g14=Duel.SelectMatchingCard(tp,c1150036.ofilter1_g13,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)				   
							if g14:GetCount()>0 then
								Duel.Remove(g14,POS_FACEUP,REASON_EFFECT)
							end
						end
					end
				end
			end
		else
			local num=roll2-roll1
			Duel.Damage(tp,roll1*100,REASON_EFFECT)
			Duel.Damage(1-tp,roll2*100,REASON_EFFECT)
			if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>2 then
				Duel.ConfirmDecktop(1-tp,3)
				local g6=Duel.GetDecktopGroup(1-tp,3)
				Duel.ShuffleDeck(1-tp)
				if g6:GetCount()>0 then
					if g6:IsExists(c1150036.ofilter1_monster,1,nil) then	 
						e:SetLabel(num+1)
						local g7=Duel.GetMatchingGroup(c1150036.ofilter1_g7,1-tp,LOCATION_GRAVE,0,nil,e,tp) 
						if g7:GetCount()>0 then
							Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
							local g8=Duel.SelectMatchingCard(1-tp,c1150036.ofilter1_g7,1-tp,LOCATION_GRAVE,0,1,1,nil)
							if g8:GetCount()>0 then
								if Duel.SpecialSummon(g8,0,1-tp,1-tp,false,false,POS_FACEUP)~=0 then
									Duel.ShuffleDeck(1-tp)
									Duel.Draw(1-tp,1,REASON_EFFECT)
								end
							end
						end
					end
					if g6:IsExists(c1150036.ofilter1_spell,1,nil) then
						local g9=Duel.GetMatchingGroup(c1150036.ofilter1_g9,1-tp,LOCATION_GRAVE,0,nil) 
						if g9:GetCount()>0 then
							Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
							local g10=Duel.SelectMatchingCard(1-tp,c1150036.ofilter1_g9,1-tp,LOCATION_GRAVE,0,1,1,nil)
							if g10:GetCount()>0 then
								if Duel.SSet(1-tp,g10)~=0 then
									local g11=Duel.GetMatchingGroup(c1150036.ofilter1_g11,1-tp,0,LOCATION_ONFIELD,nil)  
									if g11:GetCount()>0 then
										Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
										local g12=Duel.SelectMatchingCard(1-tp,c1150036.ofilter1_g11,1-tp,0,LOCATION_ONFIELD,1,1,nil)
										if g12:GetCount()>0 then
											Duel.Destroy(g12,REASON_EFFECT)
										end
									end
								end
							end
						end
					end
					if g6:IsExists(c1150036.ofilter1_trap,1,nil) then
						local g13=Duel.GetMatchingGroup(c1150036.ofilter1_g13,1-tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)   
						if g13:GetCount()>0 then
							Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
							local g14=Duel.SelectMatchingCard(1-tp,c1150036.ofilter1_g13,1-tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)				   
							if g14:GetCount()>0 then
								Duel.Remove(g14,POS_FACEUP,REASON_EFFECT)
							end
						end
					end
				end
			end
		end
	end
end